/******************************************************************************
 * Spine Runtimes Software License v2.5
 *
 * Copyright (c) 2013-2016, Esoteric Software
 * All rights reserved.
 *
 * You are granted a perpetual, non-exclusive, non-sublicensable, and
 * non-transferable license to use, install, execute, and perform the Spine
 * Runtimes software and derivative works solely for personal or internal
 * use. Without the written permission of Esoteric Software (see Section 2 of
 * the Spine Software License Agreement), you may not (a) modify, translate,
 * adapt, or develop new applications using the Spine Runtimes or otherwise
 * create derivative works or improvements of the Spine Runtimes or (b) remove,
 * delete, alter, or obscure any trademarks or any copyright, trademark, patent,
 * or other intellectual property or proprietary rights notices on or in the
 * Software, including any copy thereof. Redistributions in binary or source
 * form must include this license and terms.
 *
 * THIS SOFTWARE IS PROVIDED BY ESOTERIC SOFTWARE "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL ESOTERIC SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES, BUSINESS INTERRUPTION, OR LOSS OF
 * USE, DATA, OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *****************************************************************************/

package spine;

import spine.support.graphics.Color;
import spine.support.utils.FloatArray;
import spine.Animation.DeformTimeline;
import spine.attachments.Attachment;
import spine.attachments.VertexAttachment;

/** Stores a slot's current pose. Slots organize attachments for {@link Skeleton#drawOrder} purposes and provide a place to store
 * state for an attachment. State cannot be stored in an attachment itself because attachments are stateless and may be shared
 * across multiple skeletons. */
class Slot {
    public var data:SlotData;
    public var bone:Bone;
    public var color:Color = new Color(); public var darkColor:Color = null;
    public var attachment:Attachment;
    private var attachmentTime:Float = 0;
    private var attachmentVertices:FloatArray = new FloatArray();

    public function new(data:SlotData, bone:Bone) {
        if (data == null) throw new IllegalArgumentException("data cannot be null.");
        if (bone == null) throw new IllegalArgumentException("bone cannot be null.");
        this.data = data;
        this.bone = bone;
        darkColor = data.darkColor == null ? null : new Color();
        setToSetupPose();
    }

    /** Copy constructor. */
    /*public function new(slot:Slot, bone:Bone) {
        if (slot == null) throw new IllegalArgumentException("slot cannot be null.");
        if (bone == null) throw new IllegalArgumentException("bone cannot be null.");
        data = slot.data;
        this.bone = bone;
        color.set(slot.color);
        darkColor = slot.darkColor == null ? null : new Color(slot.darkColor);
        attachment = slot.attachment;
        attachmentTime = slot.attachmentTime;
    }*/

    /** The slot's setup pose data. */
    inline public function getData():SlotData {
        return data;
    }

    /** The bone this slot belongs to. */
    inline public function getBone():Bone {
        return bone;
    }

    /** The skeleton this slot belongs to. */
    inline public function getSkeleton():Skeleton {
        return bone.skeleton;
    }

    /** The color used to tint the slot's attachment. If {@link #getDarkColor()} is set, this is used as the light color for two
     * color tinting. */
    inline public function getColor():Color {
        return color;
    }

    /** The dark color used to tint the slot's attachment for two color tinting, or null if two color tinting is not used. The dark
     * color's alpha is not used. */
    inline public function getDarkColor():Color {
        return darkColor;
    }

    /** The current attachment for the slot, or null if the slot has no attachment. */
    inline public function getAttachment():Attachment {
        return attachment;
    }

    /** Sets the slot's attachment and, if the attachment changed, resets {@link #attachmentTime} and clears
     * {@link #attachmentVertices}.
     * @param attachment May be null. */
    inline public function setAttachment(attachment:Attachment):Void {
        if (this.attachment == attachment) return;
        this.attachment = attachment;
        attachmentTime = bone.skeleton.time;
        attachmentVertices.clear();
    }

    /** The time that has elapsed since the last time the attachment was set or cleared. Relies on Skeleton
     * {@link Skeleton#time}. */
    inline public function getAttachmentTime():Float {
        return bone.skeleton.time - attachmentTime;
    }

    inline public function setAttachmentTime(time:Float):Void {
        attachmentTime = bone.skeleton.time - time;
    }

    /** Vertices to deform the slot's attachment. For an unweighted mesh, the entries are local positions for each vertex. For a
     * weighted mesh, the entries are an offset for each vertex which will be added to the mesh's local vertex positions.
     * <p>
     * See {@link VertexAttachment#computeWorldVertices(Slot, int, int, float[], int, int)} and {@link DeformTimeline}. */
    inline public function getAttachmentVertices():FloatArray {
        return attachmentVertices;
    }

    inline public function setAttachmentVertices(attachmentVertices:FloatArray):Void {
        if (attachmentVertices == null) throw new IllegalArgumentException("attachmentVertices cannot be null.");
        this.attachmentVertices = attachmentVertices;
    }

    /** Sets this slot to the setup pose. */
    inline public function setToSetupPose():Void {
        color.set(data.color);
        if (darkColor != null) darkColor.set(data.darkColor);
        if (data.attachmentName == null)
            setAttachment(null);
        else {
            attachment = null;
            setAttachment(bone.skeleton.getAttachment(data.index, data.attachmentName));
        }
    }

    inline public function toString():String {
        return data.name;
    }
}
